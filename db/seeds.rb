# coding: utf-8

User.create!(name: "管理者",
             email: "sample@email.com",
             password: "password",
             password_confirmation: "password",
             affiliation: "上長",
             employee_number: "1",
             uid: "1",
             admin: true)
             

User.create!(name: "上長A",
             email: "sample-1@email.com",
             password: "password",
             password_confirmation: "password",
             affiliation: "上長",
             employee_number: "2",
             uid: "2",
             superior: true)
             
User.create!(name: "上長B",
             email: "sample-2@email.com",
             password: "password",
             password_confirmation: "password",
             affiliation: "上長",
             employee_number: "3",
             uid: "3",
             superior: true)
             
User.create!(name: "たつや",
             email: "sample-3@email.com",
             password: "password",
             password_confirmation: "password",
             affiliation: "上長",
             employee_number: "3",
             uid: "3")