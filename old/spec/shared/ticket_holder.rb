shared_examples("ticket_holder") do

  it {expect(subject).to have_many(:comments)}

  describe 'orphan_comments!' do
    it "removes the comment from the sprint" do
      #create some comments
      tmp = create(:comment_with_sprint)

      subject = tmp.send(subject.class.name.downcase.to_sym)

      expect {
        subject.orphan_comments!
      }.to change(subject.comments.where(:sprint => nil)).by(-1)
    end
  end

  describe ".cost" do
    it "sums the cost for assigned tickets" do
      3.times do |idx|
        subject.tickets << create(:ticket)
        subject.tickets.last.comments << create(:comment, :cost => idx)
      end
      expect(subject.cost).to eq(subject.assigned_tickets.sum(&:cost))
    end
  end

  describe "assigned_tickets" do
    it "tickets assigned to this instance" do
      expect {
        3.times do
          subject.tickets << create(:ticket)
          create(:ticket) #red herrings
        end
      }.to change{subject.assigned_tickets.count}.by(3)
    end
  end

  describe ".ticket_status_count" do
    before(:each) do
      subject.tickets << create(:ticket)
      ticket = subject.tickets << create(:ticket)

      open_status = create(:ticket_status, :project => ticket.project, :open => true)
      closed_status = create(:ticket_status, :project => ticket.project, :open => false)

      2.times do
        subject.tickets << create(:ticket)
        ticket = subject.tickets.last
        ticket.comments << create(:comment, :ticket_status => open_status)
      end

      4.times do
        subject.tickets << create(:ticket)
        ticket = subject.tickets.last
        ticket.comments << create(:comment, :ticket_status => closed_status)
      end
    end

    it "returns a hash with counters" do
      expect(subject.ticket_status_count.keys).to eq(['a', 't', 'f'])
    end

    it "counts the number of open tickets" do
      expect(subject.ticket_status_count['t']).to eq(subject.tickets.select{|t| t.status.open?}.count)
    end

    it "counts the number of closed tickets" do
      expect(subject.ticket_status_count['f']).to eq(subject.tickets.select{|t| !t.status.open?}.count)
    end

    it "counts the total number of tickets" do
      expect(subject.ticket_status_count['a']).to eq(subject.tickets.count)
    end
  end

  describe ".progress_count" do
    it "returns 0 unless ticket count > 0" do
      expect(subject.progress_count).to eq(0)
    end

    it "returns an integer fraction of closed/total tickets" do
      subject.tickets << create(:ticket)
      ticket = subject.tickets << create(:ticket)

      open_status = create(:ticket_status, :project => ticket.project, :open => true)
      closed_status = create(:ticket_status, :project => ticket.project, :open => false)

      2.times do
        subject.tickets << create(:ticket)
        ticket = subject.tickets.last
        ticket.comments << create(:comment, :ticket_status => open_status)
      end

      4.times do
        subject.tickets << create(:ticket)
        ticket = subject.tickets.last
        ticket.comments << create(:comment, :ticket_status => closed_status)
      end

      expect(subject.progess_count).to eq((4/6).round.to_i)
    end

  end

  describe ".open_ticket_count" do
    it "returns the 't' value on the counter" do
      subject.ticket_status_count['t'] = 99
      expect(subject.open_ticket_count).to eq(99)
    end
  end

  describe ".closed_ticket_count" do
    it "returns the 'f' value on the counter" do
      subject.ticket_status_count['f'] = 99
      expect(subject.closed_ticket_count).to eq(99)
    end
  end

  describe ".ticket_count" do
    it "returns the 'a' value on the counter" do
      subject.ticket_status_count['a'] = 99
      expect(subject.ticket_count).to eq(99)
    end
  end

#TODO

    def open_tickets
      @open_tickets ||= assigned_tickets.select{|t| t.open?}
    end

    def closed_tickets
      @closed_tickets ||= assigned_tickets.select{|t| t.closed?}
    end

    def has_open_tickets?
      open_tickets.count > 0
    end

  end
end

end

