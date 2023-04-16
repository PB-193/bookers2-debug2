class BookCommentsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    # パラメータで指定された投稿を検索して、変数「@book」へ格納する ※：book_idに注意！
    @comment = current_user.book_comments.new(book_comment_params)
    # 新しいコメントを生成して、変数「@comment」へ格納する。下記のストロングパラメータで指定した（:comment）のみ許可している。
    @comment.book_id = @book.id
    # 先ほど生成したコメントの投稿ID（※このbook_idはカラム）（左）に、１行目のパラメータで渡された投稿ID（右）を設定する。
    @comment.save
    redirect_to book_path(@book)
  end

  def destroy
    @book = Book.find(params[:book_id])
    @comment = current_user.book_comments.find_by(book_comment_params)
    @comment.book.id = @book.id
    @book.destroy
    redirect_to book_path(@book)
  end


  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

end
