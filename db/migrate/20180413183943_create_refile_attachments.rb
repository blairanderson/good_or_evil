class CreateRefileAttachments < ActiveRecord::Migration
  def up
    execute %Q{
      CREATE TABLE refile_attachments (
      id integer NOT NULL,
      oid oid NOT NULL,
      namespace character varying NOT NULL,
      created_at timestamp without time zone DEFAULT ('now'::text)::timestamp without time zone
      );

      CREATE SEQUENCE refile_attachments_id_seq
      START WITH 1
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      CACHE 1;

      ALTER SEQUENCE refile_attachments_id_seq OWNED BY refile_attachments.id;

      ALTER TABLE ONLY refile_attachments ALTER COLUMN id SET DEFAULT nextval('refile_attachments_id_seq'::regclass);

      ALTER TABLE ONLY refile_attachments ADD CONSTRAINT refile_attachments_pkey PRIMARY KEY (id);

      CREATE INDEX index_refile_attachments_on_namespace ON refile_attachments USING btree (namespace);

      CREATE INDEX index_refile_attachments_on_oid ON refile_attachments USING btree (oid);
    }
  end

  def drop
    drop_table :refile_attachments
  end
end

