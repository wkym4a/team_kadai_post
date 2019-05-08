module TeamHelper
  def default_img(image)
    image.presence || 'default.jpg'
  end

  def has_edit_authority_team(team_id)

    if user_signed_in? and team_id.present?

      #現在のユーザーが[チームのオーナーid]ならTを返す
      if current_user.id == Team.find(team_id).owner_id
        return true
      end

    end

    return false
  end

    def has_fired_authority(team_id,user_id)
      
      if user_signed_in? and team_id.present? and user_id.present?

        #引数として持ってきたidからチームを取得
        team=Team.find(team_id)

        #現在のユーザーが[チームのオーナー]か[やめさせようとしているユーザー自身]ならTを返す
        if current_user.id == team.owner_id || current_user.id == user_id
          return true
        end

      end

      return false
    end

end
