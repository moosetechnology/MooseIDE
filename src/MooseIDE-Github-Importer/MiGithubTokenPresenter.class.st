"
I ask the user for a Github personal access token (see https://github.com/settings/tokens) and I store it in the Iceberg credential store for github.com to authenticate the requests of the Github importer (see MiGithubRepository), raising the rate limit from 60 to 5000 requests per hour.

I replace the credential stored for github.com since the Iceberg credential store keeps one credential per host. The token also serves the git operations of Iceberg, hence the username.
"
Class {
	#name : 'MiGithubTokenPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'usernameInput',
		'tokenInput'
	],
	#category : 'MooseIDE-Github-Importer-UI',
	#package : 'MooseIDE-Github-Importer',
	#tag : 'UI'
}

{ #category : 'opening' }
MiGithubTokenPresenter class >> open [

	<script>
	^ self new openDialog
]

{ #category : 'layout' }
MiGithubTokenPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: 'Username: ' expand: false;
				   add: usernameInput;
				   yourself)
		  expand: false;
		  add: (SpBoxLayout newLeftToRight
				   add: 'Token: ' expand: false;
				   add: tokenInput;
				   yourself)
		  expand: false;
		  yourself
]

{ #category : 'private' }
MiGithubTokenPresenter >> fillFromStoredToken [
	"I prefill the fields with the stored token credential if the user stored one, to let the user edit it."

	self storedToken ifNotNil: [ :tokenCredential |
			usernameInput text: tokenCredential username.
			tokenInput text: tokenCredential token ]
]

{ #category : 'initialization' }
MiGithubTokenPresenter >> initializeDialogWindow: aDialog [

	aDialog
		addButton: 'Cancel' do: [ :dialog | dialog close ];
		addButton: 'Save' do: [ :dialog |
				self storeEnteredToken.
				dialog close ]
]

{ #category : 'initialization' }
MiGithubTokenPresenter >> initializePresenters [

	super initializePresenters.
	usernameInput := self newTextInput
		                 autoAccept: true;
		                 yourself.
	tokenInput := self newTextInput
		              autoAccept: true;
		              yourself.
	self fillFromStoredToken
]

{ #category : 'initialization' }
MiGithubTokenPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: 'Github token'.
	aWindowPresenter initialExtent: 400 @ 150
]

{ #category : 'action' }
MiGithubTokenPresenter >> storeEnteredToken [

	tokenInput text trimBoth ifEmpty: [
			self alert: 'The token cannot be empty.'.
			^ self ].

	IceCredentialStore current
		storeCredential: (IceTokenCredentials new
				 token: tokenInput text trimBoth;
				 username: usernameInput text trimBoth;
				 host: 'github.com';
				 yourself)
		forHostname: 'github.com'
]

{ #category : 'private' }
MiGithubTokenPresenter >> storedToken [

	| storedCredentials |
	storedCredentials := MiGithubRepository storedGithubCredentials.
	(storedCredentials isNotNil and: [ storedCredentials class = IceTokenCredentials ]) ifTrue: [ ^ storedCredentials ].
	^ nil
]
