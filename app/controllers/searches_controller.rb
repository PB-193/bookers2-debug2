class SearchesController < ApplicationController
  before_action :authenticate_user!

	def search
		@model = params[:model]
		@content = params[:content]
		@method = params[:method]
		if @model == 'user'
			@records = User.search_for(@content, @method)
		else
			@records = Book.search_for(@content, @method)
		end
		# @modelが'user'の場合は、users/indexパーシャルを呼び出して検索結果を表示し、
		# @modelが'book'の場合は、books/indexパーシャルを呼び出して検索結果を表示します。
	end
end
