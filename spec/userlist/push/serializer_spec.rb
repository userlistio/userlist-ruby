require 'spec_helper'

RSpec.describe Userlist::Push::Serializer do
  let(:user) do
    Userlist::Push::User.new(
      identifier: 'user-identifier',
      email: 'foo@example.com',
      signed_up_at: nil
    )
  end

  let(:company) do
    Userlist::Push::Company.new(
      'identifier': 'company-identifier',
      name: 'Example, Inc.',
      signed_up_at: nil
    )
  end

  let(:relationship) do
    Userlist::Push::Relationship.new(
      user: user,
      company: company,
      properties: {
        role: 'admin'
      }
    )
  end

  let(:event) do
    Userlist::Push::Event.new(
      user: user,
      company: company,
      name: 'example_event',
      occured_at: Time.now,
      properties: {
        null: nil,
        empty: [],
        value: 'foo'
      }
    )
  end

  before do
    user.relationships = [relationship]
    company.relationships = [relationship]
  end

  describe '#serialize' do
    let(:payload) { subject.serialize(resource) }

    context 'when serializing the user' do
      let(:resource) { user }

      it 'should return the correct payload' do
        expect(payload).to eq(
          identifier: 'user-identifier',
          email: 'foo@example.com',
          signed_up_at: nil,
          relationships: [
            {
              user: 'user-identifier',
              company: {
                identifier: 'company-identifier',
                name: 'Example, Inc.',
                signed_up_at: nil
              },
              properties: {
                role: 'admin'
              }
            }
          ]
        )
      end
    end

    context 'when serializing the company' do
      let(:resource) { company }

      it 'should return the correct payload' do
        expect(payload).to eq(
          identifier: 'company-identifier',
          name: 'Example, Inc.',
          signed_up_at: nil,
          relationships: [
            {
              company: 'company-identifier',
              user: {
                identifier: 'user-identifier',
                email: 'foo@example.com',
                signed_up_at: nil
              },
              properties: {
                role: 'admin'
              }
            }
          ]
        )
      end
    end

    context 'when serializing the relationship' do
      let(:resource) { relationship }

      it 'should return the correct payload' do
        expect(payload).to eq(
          user: {
            identifier: 'user-identifier',
            email: 'foo@example.com',
            signed_up_at: nil
          },
          company: {
            identifier: 'company-identifier',
            name: 'Example, Inc.',
            signed_up_at: nil
          },
          properties: {
            role: 'admin'
          }
        )
      end
    end

    context 'when serializing the event' do
      let(:resource) { event }

      it 'should return the correct payload' do
        expect(payload).to eq(
          name: 'example_event',
          occured_at: event.occured_at,
          user: {
            identifier: 'user-identifier',
            email: 'foo@example.com',
            signed_up_at: nil,
            relationships: [
              {
                user: 'user-identifier',
                company: {
                  identifier: 'company-identifier',
                  name: 'Example, Inc.',
                  signed_up_at: nil
                },
                properties: {
                  role: 'admin'
                }
              }
            ]
          },
          company: 'company-identifier',
          properties: {
            null: nil,
            empty: [],
            value: 'foo'
          }
        )
      end
    end
  end
end
