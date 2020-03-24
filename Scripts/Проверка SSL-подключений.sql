select pid,
ssl, --true-значит подключение зашифровано по протоколу SSL
version, --версия протокола
cipher, --шифр
bits, --разрядность алгоритма шифрования
compression, --признак сжатия
clientdn --отличительное имя (Distinguished Name DN), взятое из сертификата клиента
from pg_stat_ssl;