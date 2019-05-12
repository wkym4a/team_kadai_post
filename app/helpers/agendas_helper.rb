module AgendasHelper
  def choose_new_or_edit
    if action_name == 'new'
      team_agendas_path
    elsif action_name == 'edit'
      agenda_path
    end
  end

  def has_del_authority_agend(agend_id)
    if user_signed_in?

      #引数として持ってきたidからアジェンダを取得
      agend=Agenda.find(agend_id)

      #現在のユーザーが[アジェンダを持つチームのオーナー]か[あげんだの作成者]ならTを返す
      if current_user.id == agend.team.owner_id || current_user.id == agend.user_id
        return true
      end

    end

    return false
  end

end
