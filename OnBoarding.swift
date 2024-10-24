//
//  OnBoarding.swift
//  Saga
//
//  Created by Stavan Gandhi on 8/30/22.
//

import SwiftUI

struct OnBoarding: View {
    @State private var selectedTab: Int = 0
    
    var body: some View{
        VStack(spacing: 0){
            VStack(spacing: 0){
                Image("OnBoardingImg")
                    .resizable()
                    .frame(width: CGFloat(screenWidth()), height: CGFloat(screenHeight())/3, alignment: .center)
            }
            TabView(selection: $selectedTab){
                ScrollView{
                    tab0
                        .tag(0)
                }
                ScrollView{
                    tab1
                }
                    .tag(1)
                ScrollView{
                    tab2
                }
                    .tag(2)
                ScrollView{
                    tab3
                    NavigationLink(destination: {
                        LogInScreens()
                            .navigationBarBackButtonHidden(true)
                    }) {
                        Image(systemName: "arrow.right")
                            .padding()
                            .frame(width: CGFloat(screenWidth()), alignment: .trailing)
                            .font(.title3)
                            .foregroundColor(Color.Default)
                    }
                }
                    .tag(3)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
    
    var tab0: some View{
        VStack{
            Spacer()
            OnBoardingContainerTitle(title: "Welcome to Saga")
            OnBoardingContainerCaption(caption: "Every moment of your life deserves to be captured, and at Saga, we're dedicated to doing just that by helping you in multiple ways.")
            Spacer()
        }
        .padding(.vertical)
    }
    
    var tab1: some View{
        VStack{
            Spacer()
            OnBoardingContainerTitle(title: "Keep your thoughts organized.")
            OnBoardingContainerCaption(caption: "A journal can be frightening at first, but it is one of the most effective ways to organize your ideas. To begin, open a new journal and concentrate on one thought. Write down what you think that notion means, why you think it's essential or not, and how you can utilize it to help you achieve your goals.",
                                       caption2: "With Saga Journaling Prompts, you can start to grasp what your thoughts represent and how they can help you.")
            Spacer()
        }
        .padding(.vertical)
    }
    var tab2: some View{
        VStack{
            Spacer()
            OnBoardingContainerTitle(title: "Create Goals and Grow.")
            OnBoardingContainerCaption(caption: "Many people say that writing down your goals will help you achieve them, and this couldn't be more true. You give your ideas life by writing them down and promising yourself that you will work on them. Journaling goals will help you remember what is most important to you right now. You'll notice that some of the goals you re-write become more specific, while others change or are forgotten entirely.",
                                       caption2: "Set \"SMART\" goals while you're at it: Specific, Measurable, Achievable, Realistic, and Time-bound.")
            Spacer()
        }
        .padding(.vertical)
    }
    var tab3: some View{
        VStack{
            Spacer()
            OnBoardingContainerTitle(title: "From Confidence to Creativity.")
            OnBoardingContainerCaption(caption: "Writing a journal is an excellent way to express yourself creatively. Everyone has the ability to be creative; most of us just haven't realized it yet. The best place to begin exploring your inner creativity is in your journal. Journaling boosts confidence on multiple levels. It makes you more at ease with yourself as you learn more about yourself and your surroundings. If you journal on a regular basis, you will noticeably improve your ability to express yourself, and expressing yourself in any medium is essential for creativity. You become more eager to create once your confidence has been boosted a little.",
                                       caption2: "Anything that comes to mind should be written down. Allow your imaginations to run wild and document it in Journey.")
            Spacer()
            
        }
        .padding(.vertical)
    }
}

private struct OnBoardingContainerTitle: View{
    @State var title: String = ""
    
    var body: some View{
        Text(title)
            .font(.system(.title, design: .rounded))
            .fontWeight(.semibold)
            .padding([.horizontal,.bottom])
            .frame(width:CGFloat(screenWidth()),alignment: .leading)
    }
}

private struct OnBoardingContainerCaption: View{
    @State var caption: String = ""
    @State var caption2: String = ""
    
    var body: some View{
        VStack(alignment:.leading){
            Text(caption)
                .fontWeight(.light)
                .padding()
            
            Text(caption2)
                .fontWeight(.light)
                .padding()
        }
        .font(.system(.headline, design: .rounded))
    }
}

//
//struct OnBoarding_Previews: PreviewProvider {
//    static var previews: some View {
//        OnBoarding()
//            .previewDevice("iPhone 13 Pro")
//            .previewInterfaceOrientation(.portrait)
//    }
//}
