import boto3
import cryptography
import logging
import base64
from botocore.exceptions import ClientError
from cryptography.fernet import Fernet

logging.getLogger().setLevel(logging.INFO)
NUM_BYTES_FOR_LEN=4
BUCKET_NAME='jahidul-s3-bucket'
OBJECT_NAME = "data.txt.encrypted"

def create_data_key(cmk_id, key_spec='AES_256'):
    # Create data key
    kms_client = boto3.client('kms')
    try:
        response = kms_client.generate_data_key(KeyId=cmk_id, KeySpec=key_spec)
    except ClientError as e:
        logging.error(e)
        return None, None

    # Return the encrypted and plaintext data key
    return response['CiphertextBlob'], base64.b64encode(response['Plaintext'])


def encrypt_file(filename, cmk_id):
    try:
        with open(filename, 'rb') as file:
            file_contents = file.read()
    except IOError as e:
        logging.error(e)
        return False
    data_key_encrypted, data_key_plaintext = create_data_key(cmk_id)
    if data_key_encrypted is None:
        return False
    logging.info('Created new AWS KMS data key')

    # Encrypt the file
    f = Fernet(data_key_plaintext)
    file_contents_encrypted = f.encrypt(file_contents)
    # Write the encrypted data key and encrypted file contents together
    try:
        with open(filename + '.encrypted', 'wb') as file_encrypted:
            file_encrypted.write(len(data_key_encrypted).to_bytes(NUM_BYTES_FOR_LEN,
                                                                  byteorder='big'))
            file_encrypted.write(data_key_encrypted)
            file_encrypted.write(file_contents_encrypted)
    except IOError as e:
        logging.error(e)
        return False
    # For the highest security, the data_key_plaintext value should be wiped
    # from memory. Unfortunately, this is not possible in Python. However,
    # storing the value in a local variable makes it available for garbage
    # collection.
    return True


def decrypt_data_key(data_key_encrypted):
    # Decrypt the data key
    kms_client = boto3.client('kms')
    try:
        response = kms_client.decrypt(CiphertextBlob=data_key_encrypted)
    except ClientError as e:
        logging.error(e)
        return None

    # Return plaintext base64-encoded binary data key
    return base64.b64encode((response['Plaintext']))


def decrypt_file(filename):
    # Read the encrypted file into memory
    try:
        with open(filename + '.encrypted', 'rb') as file:
            file_contents = file.read()
    except IOError as e:
        logging.error(e)
        return False

    # The first NUM_BYTES_FOR_LEN bytes contain the integer length of the
    # encrypted data key.
    # Add NUM_BYTES_FOR_LEN to get index of end of encrypted data key/start
    # of encrypted data.
    data_key_encrypted_len = int.from_bytes(file_contents[:NUM_BYTES_FOR_LEN],
                                            byteorder='big') \
                             + NUM_BYTES_FOR_LEN
    data_key_encrypted = file_contents[NUM_BYTES_FOR_LEN:data_key_encrypted_len]

    # Decrypt the data key before using it
    data_key_plaintext = decrypt_data_key(data_key_encrypted)
    if data_key_plaintext is None:
        return False

    # Decrypt the rest of the file
    f = Fernet(data_key_plaintext)
    file_contents_decrypted = f.decrypt(file_contents[data_key_encrypted_len:])

    # Write the decrypted file contents
    try:
        with open(filename + '.decrypted', 'wb') as file_decrypted:
            file_decrypted.write(file_contents_decrypted)
    except IOError as e:
        logging.error(e)
        return False

    # The same security issue described at the end of encrypt_file() exists
    # here, too, i.e., the wish to wipe the data_key_plaintext value from
    # memory.
    return True


if __name__ == '__main__':
    encrypt_file('data.txt','alias/jislam-kms-alias' )
    s3 = boto3.resource('s3')
    client = boto3.client('s3')
    # Upload Object
    response = s3.Bucket('jahidul-s3-bucket').upload_file('data.txt.encrypted','data.txt.encrypted')
    print(response)

    # Read Object
    object_key = "data.txt.encrypted"
    file_content = client.get_object(Bucket=BUCKET_NAME, Key=object_key)["Body"].read()
    #print(file_content)

    # get file
    client.download_file(BUCKET_NAME, OBJECT_NAME, '1data.txt.encrypted')

    # decrypt file
    decrypt_file('1data.txt')

