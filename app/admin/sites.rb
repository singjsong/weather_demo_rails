ActiveAdmin.register Site do
  menu priority: 1
  permit_params :billing_status, :weather_station_installed
  actions :index

  filter :name
  filter :billing_status_eq, label: 'Billing Status', as: :select, collection: %w(unpaid paid)
  filter :weather_station_installed
  filter :created_at
  filter :updated_at

  sidebar 'Upload Sites via CSV', only: :index do
    form_for :csv, url: upload_csv_admin_sites_path, method: :post, html: { multipart: true } do
      div 'Make sure it has the columns `Site ID`, `Site Name`, `Billing Status`, `Weather Station Installed?`'

      div { file_field_tag(:file, accept: 'text/csv') }
      br
      div { submit_tag 'Update CSV' }
    end
  end

  batch_action :batch_edit do |ids|

    # TODO: still need to rename path
    @page_title = "Edit sites #{params[:collection_selection].to_sentence}"

    @sites = Site.where(id: ids)
    render 'batch_edit'
  end

  collection_action :batch_update, method: :post do
    ids = params[:ids].split(', ')
    params_to_update = params.permit(:billing_status, :weather_station_installed)
    Site.where(id: ids).update(params_to_update)

    redirect_to collection_path, notice: 'Sites updated successfully'
  end

  collection_action :upload_csv, method: :post do
    # Saving on a mac for some reason adds unnecessary bytes at the beginning of the file, which causes the CSV library
    # to fail, this just gets rid of them
    sanitized = params[:file].read.force_encoding('UTF-8')
    sites = CSV.parse(sanitized, headers: true)

    sites.to_a[1..-1].each do |site|
      Site.create!(
        id: site.first,
        name: site.second,
        billing_status: site.third.downcase,
        weather_station_installed: site.fourth == 'TRUE' ? true : false
      )
    end

    redirect_to collection_path, notice: 'Sites created successfully'
  end

  index do
    selectable_column
    column('Site ID', &:id)
    column(:name)
    column(:billing_status)
    column('Weather Station Installed?', &:weather_station_installed)
    column(:created_at)
    column(:updated_at)
  end
end
