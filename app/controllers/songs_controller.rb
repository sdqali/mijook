class SongsController < ApplicationController
  # GET /songs
  # GET /songs.json
  def index
    @songs = Song.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @songs }
    end
  end

  # GET /songs/1
  # GET /songs/1.json
  def show
    @song = Song.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @song }
    end
  end

  # GET /songs/new
  # GET /songs/new.json
  def new
    @song = Song.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @song }
    end
  end

  # GET /songs/1/edit
  def edit
    @song = Song.find(params[:id])
  end

  def pause
    respond_to do |format|
      VLC.pause
      format.html { redirect_to songs_path }
    end
  end

  def stop
    respond_to do |format|
      VLC.stop
      format.html { redirect_to songs_path }
    end
  end

  def play
    respond_to do |format|
      VLC.play
      format.html { redirect_to songs_path }
    end
  end

  def empty
    respond_to do |format|
      VLC.empty
      format.html { redirect_to songs_path }
    end
  end

  def prev
    respond_to do |format|
      VLC.prev
      format.html { redirect_to songs_path }
    end
  end

  def next
    respond_to do |format|
      VLC.next
      format.html { redirect_to songs_path }
    end
  end

  def vol_up
    respond_to do |format|
      VLC.vol_up
      format.html { redirect_to songs_path }
    end
  end

  def vol_down
    respond_to do |format|
      VLC.vol_down
      format.html { redirect_to songs_path }
    end
  end
  
  
  # POST /songs
  # POST /songs.json
  def create
    @song = Song.new(params[:song])

    respond_to do |format|
      @song.queued = false
      if @song.save
        format.html { redirect_to @song, notice: 'Song was successfully created.' }
        format.json { render json: @song, status: :created, location: @song }
      else
        format.html { render action: "new" }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
    enqueue_unqueued_songs
  end

  def enqueue_unqueued_songs
    songs_in_queue = Song.where(:queued => false)
    songs_in_queue.each do |s|
      VLC.enqueue s.url
      @song.queued = true
      @song.save
    end
    VLC.play
  end
  
  # PUT /songs/1
  # PUT /songs/1.json
  def update
    @song = Song.find(params[:id])

    respond_to do |format|
      if @song.update_attributes(params[:song])
        format.html { redirect_to @song, notice: 'Song was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    @song = Song.find(params[:id])
    @song.destroy

    respond_to do |format|
      format.html { redirect_to songs_url }
      format.json { head :ok }
    end
  end
end
