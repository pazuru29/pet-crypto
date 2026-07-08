import 'package:pet_crypto/features/user/data/datasources/user_reader_local_datasource.dart';
import 'package:pet_crypto/features/user/data/datasources/user_writer_local_datasource.dart';

abstract interface class UserLocalDatasource
    implements UserReaderLocalDatasource, UserWriterLocalDatasource {}
