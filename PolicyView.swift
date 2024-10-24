//
//  PolicyView.swift
//  Saga
//
//  Created by Stavan Gandhi on 7/27/22.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView{
            PrivacyPolicyText()
                .padding(.horizontal)
            PrivacyPolicyFooter()
                .padding(.horizontal)
                .font(.caption)
                .frame(maxWidth:.infinity,alignment: .leading)

        }
        .navigationTitle("Privacy Policy")
        .edgesIgnoringSafeArea(.bottom)
        .interactiveDismissDisabled()
    }
}

struct TermsAndConditionView: View {
    var body: some View {
        ScrollView{
            TermsAndConditionText()
                .padding(.horizontal)
            TermsAndConditionFooter()
                .padding(.horizontal)
                .font(.caption)
                .frame(maxWidth:.infinity,alignment: .leading)
        }
        .navigationTitle("Terms and Conditions")
        .edgesIgnoringSafeArea(.bottom)
        .interactiveDismissDisabled()
    }
}

struct PolicyView: View {
    @AppStorage("policyVersion") var policyVersion: Double = 0.0
    
    var body: some View {
        NavigationView{
            ScrollView{
                TermsAndConditionText()
                    .padding(.horizontal)
                TermsAndConditionFooter()
                    .padding(.horizontal)
                    .font(.caption)
                    .frame(maxWidth:.infinity,alignment: .leading)
            }
            .navigationTitle("Terms and Conditions")
            .edgesIgnoringSafeArea(.bottom)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: {
                        ScrollView{
                            PrivacyPolicyText()
                                .padding(.horizontal)
                            PrivacyPolicyFooter()
                                .padding(.horizontal)
                                .font(.caption)
                                .frame(maxWidth:.infinity,alignment: .leading)
                            
                        }
                        .navigationTitle("Privacy Policy")
                        .edgesIgnoringSafeArea(.bottom)
                        .interactiveDismissDisabled()
                    }) {
                        Text("Privacy Policy")
                    }
                }
            }
            .onAppear{
                policyVersion = PolicyVersion()
            }
        }
    }
}

