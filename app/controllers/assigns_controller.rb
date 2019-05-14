class AssignsController < ApplicationController
  before_action :authenticate_user!

  def create
    team = Team.friendly.find(params[:team_id])

    assign_info = team.invite_member_based_on_email(assign_params)

    if assign_info.id.present?

      redirect_to team_url(team), notice: 'アサインしました！'
    else
      #入力情報をセッション、エラー情報をフラッシュに保存して
      flash[:danger] = assign_info.errors.full_messages
      redirect_to team_url(team)
    end

  end

  def destroy
    assign = Assign.find(params[:id])
    destroy_message = assign_destroy(assign, assign.user)

    redirect_to team_url(params[:team_id]), notice: destroy_message
  end

  private

  def assign_params
    params[:email]
  end

  def assign_destroy(assign, assigned_user)
    if assigned_user == assign.team.owner
      'リーダーは削除できません。'
    elsif Assign.where(user_id: assigned_user.id).count == 1
      'このユーザーはこのチームにしか所属していないため、削除できません。'
    elsif assign.destroy
      set_next_team(assign, assigned_user)
      'メンバーを削除しました。'
    else
      'なんらかの原因で、削除できませんでした。'
    end
  end

  # def email_reliable?(address)
  #   address.match(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
  # end

  def set_next_team(assign, assigned_user)
    another_team = Assign.find_by(user_id: assigned_user.id).team
    change_keep_team(assigned_user, another_team) if assigned_user.keep_team_id == assign.team_id
  end
end
