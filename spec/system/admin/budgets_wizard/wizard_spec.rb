require "rails_helper"

describe "Budgets creation wizard", :admin do
  scenario "Creation of a single-heading budget by steps" do
    visit admin_budgets_path
    click_button "Create new budget"
    click_link "Create single heading budget"

    fill_in "Name", with: "Single heading budget"
    click_button "Continue to groups"

    expect(page).to have_content "New participatory budget created successfully!"
    expect(page).to have_field "Group name", with: "Single heading budget"

    click_button "Continue to headings"

    expect(page).to have_content "Group created successfully"

    fill_in "Heading name", with: "One and only heading"
    fill_in "Money amount", with: "1000000"
    click_button "Continue to phases"

    expect(page).to have_css ".budget-phases-table"

    click_button "Finish"

    expect(page).to have_content "Phases configured successfully"

    within "tr", text: "Single heading budget" do
      click_link "Edit headings groups"
    end

    expect(page).to have_content "There is 1 group"

    within "tr", text: "Single heading budget" do
      click_link "Manage headings"
    end

    expect(page).to have_content "There is 1 heading"

    within "tbody" do
      expect(page).to have_content "One and only heading"
    end
  end

  scenario "Creation of a multiple-headings budget by steps" do
    visit admin_budgets_path
    click_button "Create new budget"
    click_link "Create multiple headings budget"

    fill_in "Name", with: "Multiple headings budget"
    click_button "Continue to groups"

    expect(page).to have_content "New participatory budget created successfully!"
    expect(page).to have_content "There are no groups."

    click_button "Add new group"
    fill_in "Group name", with: "All city"
    click_button "Create new group"

    expect(page).to have_content "Group created successfully!"
    within("table") { expect(page).to have_content "All city" }
    expect(page).not_to have_content "There are no groups."

    click_button "Add new group"
    fill_in "Group name", with: "Districts"
    click_button "Create new group"

    expect(page).to have_content "Group created successfully!"
    within("table") { expect(page).to have_content "Districts" }

    click_link "Continue to headings"

    expect(page).to have_content "Showing headings from the All city group"
    expect(page).to have_content "There are no headings."

    click_button "Add new heading"
    fill_in "Heading name", with: "All city"
    fill_in "Money amount", with: "1000000"
    click_button "Create new heading"

    expect(page).to have_content "Heading created successfully!"
    within("table") { expect(page).to have_content "All city" }
    expect(page).not_to have_content "There are no headings."

    click_link "Manage headings from the Districts group."
    expect(page).to have_content "There are no headings."

    click_button "Add new heading"
    fill_in "Heading name", with: "North"
    fill_in "Money amount", with: "500000"
    click_button "Create new heading"

    expect(page).to have_content "Heading created successfully!"
    within("table") { expect(page).to have_content "North" }
    expect(page).not_to have_content "There are no headings."

    click_button "Add new heading"
    fill_in "Heading name", with: "South"
    fill_in "Money amount", with: "500000"
    click_button "Create new heading"

    expect(page).to have_content "Heading created successfully!"
    within("table") { expect(page).to have_content "South" }

    click_link "Continue to phases"

    expect(page).to have_css ".budget-phases-table"

    within("tr", text: "Voting projects") { click_link "Edit phase" }
    fill_in "Name", with: "Custom phase name"
    uncheck "Phase enabled"
    click_button "Save changes"

    expect(page).to have_content "Changes saved"

    within "table" do
      expect(page).to have_content "Custom phase name"
      expect(page).not_to have_content "Voting projects"
    end

    click_button "Finish"

    expect(page).to have_content "Phases configured successfully"

    within "tr", text: "Multiple headings budget" do
      click_link "Edit headings groups"
    end

    expect(page).to have_content "There are 2 groups"

    within "tbody" do
      expect(page).to have_content "All city"
      expect(page).to have_content "Districts"
    end

    within "tr", text: "Districts" do
      click_link "Manage headings"
    end

    expect(page).to have_content "There are 2 headings"

    within "tbody" do
      expect(page).to have_content "North"
      expect(page).to have_content "South"
    end
  end
end
