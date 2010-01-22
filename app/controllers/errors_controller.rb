class ErrorsController < ApplicationController
  def create
    
    msgstr = "
        From: Your Name <your@mail.address>
        To: Destination Address <someone@example.com>
        Subject: test message
        Date: Sat, 23 Jun 2001 16:26:43 +0900
        Message-Id: <unique.message.id.string@example.com>

        This is a test message.
        END_OF_MESSAGE"

     require 'net/smtp'
     
     puts '******************* ERRORS CONTROLLER'
     body = params.inspect[1..-2].split(':').join('').split('=>').join(': ').split('"').join('')
     puts body
     
     
     # using block form of SMTP.start
        # Net::SMTP.start('localhost.localdomain', 25) do |smtp|
        #   smtp.send_message msgstr, 'errors@tuneful.org', 'thekevinscott@gmail.com'
         #end
     
    respond_to do |format|
      format.html
    end
  end
end
