#
# Cookbook Name:: percona
# Attributes:: default
#
# Copyright ModCloth, Inc.
#
# All rights reserved - Do Not Redistribute
#

# General attributes
default[:percona][:bind_address]                                 = '127.0.0.1'
default[:percona][:server_id]                                    = `ifconfig -a | grep 192 | awk '{print $2}' | awk -F"." '{print $3$4}'`.strip.to_i
default[:percona][:replica_specific]                             = 'no'

# Tunable attributes
default[:percona][:tunable][:max_connections]                    = '1500'
default[:percona][:tunable][:connect_timeout]                    = '10'
default[:percona][:tunable][:net_read_timeout]                   = '10'
default[:percona][:tunable][:net_write_timeout]                  = '10'
default[:percona][:tunable][:net_buffer_length]                  = '16384'
default[:percona][:tunable][:read_buffer_size]                   = '16M'
default[:percona][:tunable][:table_cache]                        = '256'
default[:percona][:tunable][:thread_cache]                       = '256'
default[:percona][:tunable][:innodb_buffer_pool_size]            = '512M'
default[:percona][:tunable][:innodb_buffer_pool_instances]       = '1'
default[:percona][:tunable][:innodb_read_io_threads]             = '8'
default[:percona][:tunable][:innodb_write_io_threads]            = '8'
default[:percona][:tunable][:innodb_io_capacity]                 = '1000'
default[:percona][:tunable][:innodb_lock_wait_timeout]           = '5'
default[:percona][:tunable][:query_cache_size]                   = '16M'
default[:percona][:tunable][:query_cache_limit]                  = '100K'
default[:percona][:tunable][:max_allowed_packet]                 = '32M'
default[:percona][:tunable][:slave_max_allowed_packet]           = '32M'
default[:percona][:tunable][:event_scheduler]                    = 'OFF'
default[:percona][:tunable][:group_concat_max_len]               = '1024'
default[:percona][:tunable][:replicate_wild_do_table]            = ' '
default[:percona][:tunable][:replicate_ignore_table]             = ' '
default[:percona][:tunable][:tmp_table_size]                     = '16M'
default[:percona][:tunable][:tmp_dir]                            = '/var/tmp'
default[:percona][:tunable][:max_heap_table_size]                = '256M'
default[:percona][:tunable][:expire_log_days]                    = '3'
default[:percona][:tunable][:binlog_format]                      = 'MIXED'
default[:percona][:tunable][:character_set_server]               = 'utf8'
default[:percona][:tunable][:collation_server]                   = 'utf8_unicode_ci'
default[:percona][:tunable][:log_queries_not_using_indexes]      = 'OFF'
default[:percona][:tunable][:transaction_isolation]              = 'REPEATABLE-READ'
default[:percona][:tunable][:auto_increment_increment]           = '1'
default[:percona][:tunable][:auto_increment_offset]              = '1'
default[:percona][:tunable][:thread_stack]                       = '128K'
default[:percona][:tunable][:slave_type_conversions]             = 'ALL_NON_LOSSY'
default[:percona][:tunable][:query_cache_type]                   = 'ON'
default[:percona][:tunable][:query_cache_size]                   = '16M'
default[:percona][:tunable][:query_cache_limit]                  = '4096'
default[:percona][:tunable][:query_cache_min_res_unit]           = '512'
default[:percona][:tunable][:table_open_cache]                   = '1024'
default[:percona][:tunable][:table_definition_cache]             = '1024'
default[:percona][:tunable][:replicate_wild_do_table]            = ' '
default[:percona][:tunable][:replicate_ignore_table]             = ' '
default[:percona][:tunable][:userstat]                           = 'OFF'
default[:percona][:tunable][:innodb_flush_log_at_trx_commit]     = '1'
default[:percona][:tunable][:sync_binlog]                        = '0' 

# Backup attributes
default[:percona][:backup][:retention_period]                    = '7'
default[:percona][:backup][:crontab_schedule]                    = %w(0 8 * * *)
