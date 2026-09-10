"
I am a MiGithubRepository that answers canned responses instead of querying the Github API, to test the Github importer without network. I map query paths to answers with #at:put:.
"
Class {
	#name : 'MiGithubRepositoryStub',
	#superclass : 'MiGithubRepository',
	#instVars : [
		'responses'
	],
	#category : 'MooseIDE-Github-Importer-Tests-Tests',
	#package : 'MooseIDE-Github-Importer-Tests',
	#tag : 'Tests'
}

{ #category : 'credentials' }
MiGithubRepositoryStub class >> storedGithubCredentials [
	"For the tests I answer a fake token so that the api wiring can be tested without touching the real Iceberg credential store."

	^ self pickGithubCredentialFrom: { (IceTokenCredentials new
			   token: 'fakeToken';
			   username: 'testUser';
			   host: 'github.com';
			   yourself) }
]

{ #category : 'accessing' }
MiGithubRepositoryStub >> at: aPath put: aResponse [

	responses at: aPath put: aResponse
]

{ #category : 'requesting' }
MiGithubRepositoryStub >> get: aPath [

	^ responses at: aPath ifAbsent: [ self error: 'Unexpected query: ' , aPath ]
]

{ #category : 'requesting' }
MiGithubRepositoryStub >> get: aPath parameters: aDictionary [

	^ responses at: aPath ifAbsent: [ self error: 'Unexpected query: ' , aPath ]
]

{ #category : 'initialization' }
MiGithubRepositoryStub >> initialize [

	super initialize.
	responses := Dictionary new
]
