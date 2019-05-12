class AgendasController < ApplicationController
  include AgendasHelper

  # before_action :set_agenda, only: %i[show edit update destroy]
  before_action :chk_before_del, only: [:destroy]
  before_action :set_agenda, only: [:destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: 'アジェンダ作成に成功しました！'
    else
      render :new
    end
  end

  #issue1で追加
  def destroy

    #『削除後に報告メールを送るメンバー』を予め取得
    # ……【削除対象であるアジェンダ→それを持っているチーム→所属しているメンバー】が対象
    agenda_title = @agenda.title
    send_to_members =  @agenda.team.members

    #アジェンダを削除→紐づく「記事」（および、記事に紐づく「コメント」も自動で削除されるはず
    @agenda.destroy

    #チームメンバーに削除した旨をメールで報告する
    DelAgendaMailer.del_agenda_mail(agenda_title, send_to_members).deliver

    #「アジェンダ」を削除→紐づく「記事」（および、記事に紐づく「コメント」も自動で削除されるはず
    redirect_to dashboard_url,
     notice: 'アジェンダ削除に成功しました。チームメンバーにも報告メールを送っています。'

  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end

  def chk_before_del
    if not has_del_authority_agend(params[:id])
    redirect_to dashboard_url,
     notice: '削除権限が無いため、アジェンダを削除できません。'

    end
  end
end
