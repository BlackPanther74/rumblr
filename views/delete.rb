get "delete" do
  current_user
  current_user.destroy
  current session to nil
  redirect '/'
end