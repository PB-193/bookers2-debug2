class FavoritesController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    @favorite = @book.favorites.new(user_id: current_user.id)
    @favorite.save
    # redirect_to request.referer  通常の場合、「非同期通信ではない場合」　非同期通信の時はredirectしないので削除！
    # 「非同期通信」→ リダイレクト先を削除したことにより、リダイレクト先がない、かつJavaScriptリクエストという状況になり、
    # createアクション実行後は、create.js.erbファイルを、destroyアクション実行後はdestroy.js.erbファイルを探すようになります。

  end
  
  def destroy
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: @book.id)
    favorite.destroy
    # redirect_to request.referer
  end
  
end
