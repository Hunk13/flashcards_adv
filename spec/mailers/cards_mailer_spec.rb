describe "Testing Notification Mailer" do
  context "pending card" do
    let!(:user) { create(:user) }
    let!(:mail) { CardsMailer.pending_cards_notification(user) }

    it "render subject mail" do
      expect(mail.subject).to eql("Наступила дата пересмотра карточек.")
    end

    it "send mail to" do
      expect(mail.to).to eql([user.email])
    end

    it "send mail from" do
      expect(mail.from).to eql(["admin@flashcards.ru"])
    end
  end
end
