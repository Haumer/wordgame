class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update]
  def show
    @user = User.find(params[:id])
    @download = params[:download].present?
    if @download && @user.batches.last
      @batch = @user.batches.last
      @words_stats = words_stats(@batch.words)
      @batches = Batch.find(@user.batches.pluck(:id) - [@batch.id])
    else
      @batches = @user.batches
    end
  end

  def update
    if @user.update(strong_params)
      flash[:notice] = 'Erfolgreich gespeichert'
    else
      flash[:notice] = @user.sheet_url.nil? || @user.sheet_url.empty? ? 'Url nicht vorhanden' : 'Das hat nicht funktioniert'
    end
    redirect_to user_path(@user)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def strong_params
    params.require(:user).permit(:sheet_url)
  end

  private

  def words_stats(words)
    Struct.new('WordsStats', :same_length, :shortest_words, :longest_words)
    if words.present?
      same_length = words.all? { |word| word.value.length == words.first.value.length }
      sorted_words = words.sort_by { |word| word.value.length }
      shortest_length = sorted_words.first.value.length
      longest_length = sorted_words.last.value.length
      shortest_words = words.select { |word| word.value.length == shortest_length }
      longest_words = words.select { |word| word.value.length == longest_length }
      Struct::WordsStats.new(same_length, shortest_words, longest_words)
    else
      Struct::WordsStats.new(true, [], [])
    end

  end
end
