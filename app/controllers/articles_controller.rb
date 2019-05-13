class ArticlesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article, only: %i[show edit update destroy]

  def index
    @agendas = Agenda.all
    @articles = Article.all
  end

  def show

    @comments = @article.comments
    @comment = @article.comments.build
    @working_team = @article.team
    change_keep_team(current_user, @working_team)
  end

  def new

    @agenda = Agenda.find(params[:agenda_id])
    @team = @agenda.team
    @article = @agenda.articles.build

    if session["agenda_" + @article.agenda_id.to_s + "_article"].present?
      #session情報がある場合はそれを取得して、取得したsessionはクリアする（エラー発生によりredirect_toした場合の処理）
      @article = Article.new(session["agenda_" + @article.agenda_id.to_s + "_article"])

      session["agenda_" + @article.agenda_id.to_s + "_article"] = nil

    end

  end

  def edit
    change_keep_team(current_user, @article.team)
  end

  def create

    @agenda = Agenda.find(params[:agenda_id])
    @article = @agenda.articles.build(article_params)
    @article.user = current_user
    @article.team_id = @agenda.team_id

    if @article.save
      redirect_to article_url(@article), notice: '記事作成に成功しました！'
    else

      #入力情報をセッション、エラー情報をフラッシュに保存して
      session["agenda_" + @article.agenda_id.to_s + "_article"] = @article
      flash[:danger] = @article.errors.full_messages
      #redirect_to(renderだとurlがおかしくなるため)
      redirect_to new_agenda_article_path(@agenda.id)

      # render :new
    end
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: '記事更新に成功しました！'
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to dashboard_url
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.fetch(:article, {}).permit %i[title content image image_cache]
  end
end
