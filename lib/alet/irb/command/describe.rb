require 'optparse'
require 'stringio'
require 'irb/pager'
require 'sobject_model/schema'

class Describe < IRB::Command::Base
  category "Alet"
  description t('desc.description')
  help_message TTY::Markdown.parse t('desc.help')

  def execute(arg)
    argv = arg.split(' ')
    opt = OptionParser.new
    opt.on '-r', '--relation'
    opt.on '-t', '--record-type'
    opt.on '-a', '--all'

    params = {}
    opt.parse(argv, into: params)

    object_type = argv.first

    schema = SObjectModel::Schema.new(Alet.describe(object_type.to_sym))

    if params.has_key?(:relation)
      show_relations(schema)
    elsif params.has_key?(:"record-type")
      show_record_types(schema)
    elsif params.has_key?(:all)
      show_all(schema)
    else
      show_fields(schema)
    end
  end

  def show_fields(schema)
    table = create_field_table(schema)
    sio = StringIO.new
    sio << t('desc.table.field')
    sio << "\n"
    sio << table.render(:unicode)
    IRB::Pager.page_content(sio.string)
  end

  def show_relations(schema)
    table = crate_relation_table(schema)
    sio = StringIO.new
    sio << t('desc.table.relation')
    sio << "\n"
    sio << table.render(:unicode)
    IRB::Pager.page_content(sio.string)
  end

  def show_record_types(schema)
    table = create_record_type_table(schema)
    sio = StringIO.new
    sio << t('desc.table.record_type')
    sio << "\n"
    sio << table.render(:unicode)
    IRB::Pager.page_content(sio.string)
  end

  def show_all(schema)
    field_table = create_field_table(schema)
    relation_table = crate_relation_table(schema)
    record_type_table = create_record_type_table(schema)

    sio = StringIO.new
    sio << t('desc.table.field')
    sio << "\n"
    sio << field_table.render(:unicode)
    sio << "\n"
    sio << "\n"
    sio << t('desc.table.relation')
    sio << "\n"
    sio << relation_table.render(:unicode)
    sio << "\n"
    sio << "\n"
    sio << t('desc.table.record_type')
    sio << "\n"
    sio << record_type_table.render(:unicode)
    IRB::Pager.page_content(sio.string)
  end

  def create_field_table(schema)
    rows = []
    schema.fields.each do |f|
      if f.picklist_values.empty?
        rows << [f.label, f.name, f.type, '']
      else
        f.picklist_values.each_with_index do |pv, i|
          next unless pv.active
          if i == 0
            rows << [f.label, f.name, f.type, %|#{f.label}/#{pv.value}|]
          else
            rows << ['', '', '', %|#{f.label}/#{pv.value}|]
          end
        end
      end
    end

    TTY::Table.new(
      [t('desc.column.label'), t('desc.column.name'), t('desc.column.type'), ''],
      rows)
  end

  def crate_relation_table(schema)
    rows =
      schema.parent_relations.map{|r| [r[:name], t('desc.relation_type.parent'), r[:class_name], r[:field]]} +
      schema.child_relations.map{|r| [r[:name], t('desc.relation_type.child'), r[:class_name], r[:field]]}

    TTY::Table.new(
      [t('desc.column.relation_name'), t('desc.column.relation_type'), t('desc.column.relation_class'), t('desc.column.relation_field')],
      rows)
  end

  def create_record_type_table(schema)
    rows  = schema.record_types
            .select{|rt| rt.active && rt.available}
            .map{|rt| [rt.name, rt.recordTypeId, rt.developerName]}

    TTY::Table.new(
      [t('desc.column.record_type_name'), t('desc.column.record_type_id'), t('desc.column.record_type_developer_name')],
      rows)
  end
end
