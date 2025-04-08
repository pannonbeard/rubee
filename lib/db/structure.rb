# frozen_string_literal: true

STRUCTURE = {
  users: {
    id: {
      generated: false,
      allow_null: false,
      default: nil,
      db_type: 'INTEGER',
      primary_key: true,
      auto_increment: true,
      type: 'integer',
      ruby_default: nil
    },
    email: {
      generated: false,
      allow_null: true,
      default: nil,
      db_type: 'varchar(255)',
      primary_key: false,
      type: 'string',
      ruby_default: nil,
      max_length: 255
    },
    password: {
      generated: false,
      allow_null: true,
      default: nil,
      db_type: 'varchar(255)',
      primary_key: false,
      type: 'string',
      ruby_default: nil,
      max_length: 255
    }
  },
  accounts: {
    id: {
      generated: false,
      allow_null: false,
      default: nil,
      db_type: 'INTEGER',
      primary_key: true,
      auto_increment: true,
      type: 'integer',
      ruby_default: nil
    },
    addres: {
      generated: false,
      allow_null: true,
      default: nil,
      db_type: 'varchar(255)',
      primary_key: false,
      type: 'string',
      ruby_default: nil,
      max_length: 255
    },
    user_id: {
      generated: false,
      allow_null: true,
      default: nil,
      db_type: 'INTEGER',
      primary_key: false,
      type: 'integer',
      ruby_default: nil
    }
  },
  posts: {
    id: {
      generated: false,
      allow_null: false,
      default: nil,
      db_type: 'INTEGER',
      primary_key: true,
      auto_increment: true,
      type: 'integer',
      ruby_default: nil
    },
    user_id: {
      generated: false,
      allow_null: true,
      default: nil,
      db_type: 'INTEGER',
      primary_key: false,
      type: 'integer',
      ruby_default: nil
    },
    comment_id: {
      generated: false,
      allow_null: true,
      default: nil,
      db_type: 'INTEGER',
      primary_key: false,
      type: 'integer',
      ruby_default: nil
    }
  },
  comments: {
    id: {
      generated: false,
      allow_null: false,
      default: nil,
      db_type: 'INTEGER',
      primary_key: true,
      auto_increment: true,
      type: 'integer',
      ruby_default: nil
    },
    text: {
      generated: false,
      allow_null: true,
      default: nil,
      db_type: 'varchar(255)',
      primary_key: false,
      type: 'string',
      ruby_default: nil,
      max_length: 255
    },
    user_id: {
      generated: false,
      allow_null: true,
      default: nil,
      db_type: 'INTEGER',
      primary_key: false,
      type: 'integer',
      ruby_default: nil
    }
  }
}.freeze
