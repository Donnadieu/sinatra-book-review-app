


      it 'lets a user edit their own review if they are logged in' do
        user = User.create(:username => "User Test", :email => "test@email.com", :password => "123456")
        review = Review.create(:content => "reviewing!", :user_id => 1)

        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'Login'
        visit "/reviews/#{review.id}/edit"

        fill_in(:content, :with => "i love reviewing")

        click_button 'submit'
        expect(Review.find_by(:content => "i love reviewing")).to be_instance_of(Review)
        expect(Review.find_by(:content => "reviewing!")).to eq(nil)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user edit a text with blank content' do
        user = User.create(:username => "User Test", :email => "test@email.com", :password => "123456")
        review = Review.create(:content => "reviewing!", :user_id => 1)
        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'Login'
        visit '/reviews/1/edit'

        fill_in(:content, :with => "")

        click_button 'submit'
        expect(Review.find_by(:content => "i love reviewing")).to be(nil)
        expect(page.current_path).to eq("/reviews/1/edit")
      end
    end

    context "logged out" do
      it 'does not load let user view review edit form if not logged in' do
        get '/reviews/1/edit'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'delete action' do
    context "logged in" do
      it 'lets a user delete their own review if they are logged in' do
        user = User.create(:username => "User Test", :email => "test@email.com", :password => "123456")
        review = Review.create(:content => "reviewing!", :user_id => 1)
        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'submit'
        visit 'reviews/1'
        click_button "Delete Review"
        expect(page.status_code).to eq(200)
        expect(Review.find_by(:content => "reviewing!")).to eq(nil)
      end

      it 'does not let a user delete a review they did not create' do
        user1 = User.create(:username => "User Test", :email => "test@email.com", :password => "123456")
        review1 = Review.create(:content => "reviewing!", :user_id => user1.id)

        user2 = User.create(:username => "User Test2", :email => "email@aol.com", :password => "789456")
        review2 = Review.create(:content => "look at this review", :user_id => user2.id)

        visit '/login'

        fill_in(:email, :with => "test@email.com")
        fill_in(:password, :with => "123456")
        click_button 'Login'
        visit "reviews/#{review2.id}"
        click_button "Delete Review"
        expect(page.status_code).to eq(200)
        expect(Review.find_by(:content => "look at this review")).to be_instance_of(Review)
        expect(page.current_path).to include('/reviews')
      end
    end

    context "logged out" do
      it 'does not load let user delete a review if not logged in' do
        review = Review.create(:content => "reviewing!", :user_id => 1)
        visit '/reviews/1'
        expect(page.current_path).to eq("/login")
      end
    end
  end
end
