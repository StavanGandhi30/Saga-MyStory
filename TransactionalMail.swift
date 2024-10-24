//
//  TransactionalMail.swift
//  Saga
//
//  Created by Stavan Gandhi on 8/24/22.
//

import SwiftUI
import SwiftSMTP

class TransactionalMail{
    static let send = TransactionalMail()
    
    func verificationEmail(_ email: String, _ verificationCode: Int){
        self.sendMail(
            from: getUserVerificationEmail(),
            to: email,
            subject: "Saga: Email Verification",
            message: self.verifyEmailTemplate(verificationCode, userEmail: email)
        )
    }
    
    func newUserEmail(_ email: String){
        self.sendMail(
            from: "saga.mystory.new@gmail.com",
            to: email,
            subject: "Welcome to Saga",
            message: self.newUserEmailTemplate(email)
        )
    }
}


extension TransactionalMail{
    private func sendMail(from: String, to: String, subject: String, message: String, completion: ((String?) -> Void)? = nil){
        let mail = Mail(
            from: Mail.User(name: "Saga", email: from),
            to: [
                Mail.User(name: "User", email: to)
            ],
            subject: subject,
            text: message
        )
        
        self.sendSMTP(from, mail) { error in
            guard let err = error else{
                completion?(nil)
                return
            }
            completion?(err)
        }
    }
    
    private func sendSMTP(_ from: String, _ mail: Mail, completion: ((String?) -> Void)? = nil){
        self.getSMTP(from).send(mail) { (error) in
            guard let err = error?.localizedDescription else{
                completion?(nil)
                return
            }
            completion?(err)
        }
    }
    
    private func getSMTP(_ email: String) -> SMTP{
        print("\(email): \(Bundle.main.infoDictionary?[email] as? String ?? "")")
        return SMTP(
            hostname: "smtp.gmail.com",     // SMTP server address
            email: email,        // username to login
            password: Bundle.main.infoDictionary?[email] as? String ?? ""            // password to login
        )
    }
    
    private func getUserVerificationEmail() -> String {
        var verificationEmail : [String] = [
            "saga.mystory.user1@gmail.com",
            "saga.mystory.user2@gmail.com",
            "saga.mystory.user3@gmail.com"
        ]
        
        let index: Int = Int(arc4random_uniform(UInt32(verificationEmail.count)))
        
        
        return verificationEmail[index]
    }
}


extension TransactionalMail{    
    private func verifyEmailTemplate(_ verificationCode: Int, userEmail: String) -> String{
        let template = """
Hi \(userEmail)!
Your verification code is \(verificationCode).

Enter this code in your Saga app to activate your account.

If you didn’t ask to verify this Email Address, you can ignore this email.

If you have any questions, send us an email Saga.MyStory.help@gmail.com .

Device Name: \(UIDevice.current.name)
Device Model: \(UIDevice.current.model)

Thanks,
Your Saga Team
"""

        return template
    }
    
    private func newUserEmailTemplate(_ userEmail: String) -> String{
        let template = """
Hi \(userEmail)!

Welcome to Saga!
Thank you for signing up for Saga Mobile App.

Every moment of your life deserves to be captured, and at Saga, we're dedicated to doing just that by helping you in multiple ways.

Keep your thoughts organized.

    A journal can be frightening at first, but it is one of the most effective ways to organize your ideas. To begin, open a new journal and concentrate on one thought. Write down what you think that notion means, why you think it's essential or not, and how you can utilize it to help you achieve your goals.
    With Saga Journaling Prompts, you can start to grasp what your thoughts represent and how they can help you.

Track your progress and growth.

    Many people say that writing down your goals will help you achieve them, and this couldn't be more true. You give your ideas life by writing them down and promising yourself that you will work on them. Journaling goals will help you remember what is most important to you right now (you'll notice that some of the goals you re-write become more specific, while others change or are forgotten entirely).
    Set "SMART" goals while you're at it: Specific, Measurable, Achievable, Realistic, and Time-bound.

From Confidence to Creativity.
    Writing a journal is an excellent way to express yourself creatively. Everyone has the ability to be creative; most of us just haven't realized it yet. The best place to begin exploring your inner creativity is in your journal. Journaling boosts confidence on multiple levels. It makes you more at ease with yourself as you learn more about yourself and your surroundings. If you journal on a regular basis, you will noticeably improve your ability to express yourself, and expressing yourself in any medium is essential for creativity. You become more eager to create once your confidence has been boosted a little. Anything that comes to mind should be written down.
    Allow your imaginations to run wild and document it in Journey.

If you have any questions, send us an email Saga.MyStory.help@gmail.com.

Thanks,
Your Saga Team
"""

        return template
    }
}


/**
 
 saga.mystory@gmail.com
 
 // For User Usage:
 
 To send any support email.
 saga.mystory.user1@gmail.com
 drubypnhojapmaby
 
 saga.mystory.user2@gmail.com
 wiauyxrommyiyqws
 
 saga.mystory.user3@gmail.com
 ntrxtklypcrwfevt
 
 To send new feature email.
 saga.mystory.new@gmail.com
 oniqckerrngmgusg
 
 
 // For Saga Usage:
 
 To send any verification code email.
 saga.mystory.verify@gmail.com
 
 To send any support email.
 saga.mystory.help@gmail.com
 
 To send any new user email.
 saga.mystory.newuser@gmail.com
 
 */
