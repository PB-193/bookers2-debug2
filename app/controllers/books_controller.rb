class BooksController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @book = Book.find_by(id:params[:id])
    @user = @book.user
    @book1 = Book.new
    @book_comment = BookComment.new
  end

  def index
    @books = Book.all
    @book = Book.new
    @user = current_user
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    @user = current_user
    @book.save
    redirect_to book_path(@book), notice: "You have created book successfully."
  end

  def edit
    @book = Book.find(params[:id])
    @user = @book.user
  end

  def update
    @book = Book.find(params[:id])
    @user = @book.user
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      @books = Book.all
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end
  

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

# 特定のアクションを実行する前に、現在のユーザーがそのアクションを実行する権限を持っているかどうかを確認するために使用されます。
# このようにすることで、ユーザーが他のユーザーの情報を編集したり、削除したりすることを防ぎ、セキュリティを強化することができます。
  def ensure_correct_user
  @book = Book.find(params[:id])
  @user = @book.user
    unless @user == current_user
      redirect_to books_path
    end
  end

end
