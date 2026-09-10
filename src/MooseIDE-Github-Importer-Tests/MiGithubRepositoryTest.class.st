"
I test MiGithubRepository: parsing of the user input into a repository, mapping of Github API answers into versions and computation of the download URL. I never access the network thanks to MiGithubRepositoryStub.
"
Class {
	#name : 'MiGithubRepositoryTest',
	#superclass : 'TestCase',
	#instVars : [
		'repository'
	],
	#category : 'MooseIDE-Github-Importer-Tests-Tests',
	#package : 'MooseIDE-Github-Importer-Tests',
	#tag : 'Tests'
}

{ #category : 'fixtures' }
MiGithubRepositoryTest >> plaintextCredential [

	^ IcePlaintextCredentials new
		  username: 'testUser';
		  password: 'ghp_fakePassword';
		  host: 'github.com';
		  yourself
]

{ #category : 'running' }
MiGithubRepositoryTest >> setUp [

	super setUp.
	repository := MiGithubRepositoryStub owner: 'moosetechnology' projectName: 'MooseIDE'
]

{ #category : 'tests' }
MiGithubRepositoryTest >> testApiUsesStoredCredentials [
	"The class of the stub answers a fake token credential, so the requests of the api must be authenticated with it."

	self assert: repository api credentials token equals: 'fakeToken'
]

{ #category : 'tests' }
MiGithubRepositoryTest >> testAvailableVersions [

	repository
		at: 'repos/moosetechnology/MooseIDE/tags' put: { { ('name' -> 'v1.0') } asDictionary };
		at: 'repos/moosetechnology/MooseIDE/branches' put: { { ('name' -> 'main') } asDictionary };
		at: 'repos/moosetechnology/MooseIDE/releases' put: { { ('tag_name' -> 'v1.0') } asDictionary };
		at: 'repos/moosetechnology/MooseIDE/pulls' put: { {
				('number' -> 42).
				('title' -> 'Fix bug') } asDictionary }.

	self assert: repository availableVersions size equals: 4
]

{ #category : 'tests' }
MiGithubRepositoryTest >> testBranches [

	repository at: 'repos/moosetechnology/MooseIDE/branches' put: { { ('name' -> 'main') } asDictionary }.

	self assert: repository branches size equals: 1.
	self assert: repository branches anyOne displayName equals: 'main'.
	self assert: repository branches anyOne kind equals: #branch.
	self assert: repository branches anyOne downloadRef equals: 'refs/heads/main'
]

{ #category : 'tests' }
MiGithubRepositoryTest >> testDownloadUrlForVersion [

	| version |
	version := MiGithubVersion tagNamed: 'v1.0'.

	self assert: (repository downloadUrlForVersion: version) equals: 'https://codeload.github.com/moosetechnology/MooseIDE/tar.gz/refs/tags/v1.0'
]

{ #category : 'tests' }
MiGithubRepositoryTest >> testFromFullName [

	| parsedRepository |
	parsedRepository := MiGithubRepository fromFullName: 'moosetechnology/MooseIDE'.

	self assert: parsedRepository owner equals: 'moosetechnology'.
	self assert: parsedRepository projectName equals: 'MooseIDE'
]

{ #category : 'tests' }
MiGithubRepositoryTest >> testPickGithubCredentialFallsBackToPlaintext [

	| plaintext |
	plaintext := self plaintextCredential.

	self assert: (MiGithubRepository pickGithubCredentialFrom: { plaintext }) identicalTo: plaintext
]

{ #category : 'tests' }
MiGithubRepositoryTest >> testPickGithubCredentialIgnoresEmptyCredentials [

	| emptyToken |
	emptyToken := IceTokenCredentials new
		              token: '';
		              host: 'github.com';
		              yourself.

	self assert: (MiGithubRepository pickGithubCredentialFrom: { emptyToken }) isNil
]

{ #category : 'tests' }
MiGithubRepositoryTest >> testPickGithubCredentialIgnoresOtherHosts [

	| otherHostToken |
	otherHostToken := IceTokenCredentials new
		                  token: 'ghp_sometoken';
		                  host: 'gitlab.com';
		                  yourself.

	self assert: (MiGithubRepository pickGithubCredentialFrom: { otherHostToken }) isNil
]

{ #category : 'tests' }
MiGithubRepositoryTest >> testPickGithubCredentialPrefersToken [

	| token |
	token := self tokenCredential.

	self
		assert: (MiGithubRepository pickGithubCredentialFrom: {
					 token.
					 self plaintextCredential })
		identicalTo: token
]

{ #category : 'tests' }
MiGithubRepositoryTest >> testPickGithubCredentialWithoutCredentials [

	self assert: (MiGithubRepository pickGithubCredentialFrom: {  }) isNil
]

{ #category : 'tests' }
MiGithubRepositoryTest >> testPrimaryLanguage [

	repository at: 'repos/moosetechnology/MooseIDE' put: { ('language' -> 'Java') } asDictionary.

	self assert: repository primaryLanguage equals: 'Java'
]

{ #category : 'tests' }
MiGithubRepositoryTest >> testPrimaryLanguageUnknown [

	repository at: 'repos/moosetechnology/MooseIDE' put: { ('language' -> nil) } asDictionary.

	self assert: repository primaryLanguage isNil
]

{ #category : 'tests' }
MiGithubRepositoryTest >> testPullRequests [

	repository at: 'repos/moosetechnology/MooseIDE/pulls' put: { {
			('number' -> 42).
			('title' -> 'Fix bug') } asDictionary }.

	self assert: repository pullRequests size equals: 1.
	self assert: repository pullRequests anyOne displayName equals: 'Pull request #42: Fix bug'.
	self assert: repository pullRequests anyOne kind equals: #pullRequest.
	self assert: repository pullRequests anyOne downloadRef equals: 'refs/pull/42/head'
]

{ #category : 'tests' }
MiGithubRepositoryTest >> testReleases [

	repository at: 'repos/moosetechnology/MooseIDE/releases' put: { { ('tag_name' -> 'v1.0') } asDictionary }.

	self assert: repository releases size equals: 1.
	self assert: repository releases anyOne displayName equals: 'v1.0'.
	self assert: repository releases anyOne kind equals: #release.
	self assert: repository releases anyOne downloadRef equals: 'refs/tags/v1.0'
]

{ #category : 'tests' }
MiGithubRepositoryTest >> testRepositorySearchQueryDropsOwnersWhenTooLong [

	| longLogins query |
	longLogins := (1 to: 20) collect: [ :each | 'aVeryLongOwnerLoginName' , each asString ].
	query := repository repositorySearchQueryFromNamePart: 'Tiny' ownerLogins: longLogins.

	self assert: query size <= MiGithubRepository maximumSearchQuerySize.
	self assert: (query beginsWith: 'Tiny in:name')
]

{ #category : 'tests' }
MiGithubRepositoryTest >> testRepositorySearchQueryFromLoginsOnly [

	self assert: (repository repositorySearchQueryFromNamePart: '' ownerLogins: { 'jecisc'. 'jech' }) equals: 'user:jecisc user:jech'
]

{ #category : 'tests' }
MiGithubRepositoryTest >> testRepositorySearchQueryFromNamePartAndLogins [

	self assert: (repository repositorySearchQueryFromNamePart: 'Tiny' ownerLogins: { 'jecisc' }) equals: 'Tiny in:name user:jecisc'
]

{ #category : 'tests' }
MiGithubRepositoryTest >> testRepositorySearchQueryFromNamePartOnly [

	self assert: (repository repositorySearchQueryFromNamePart: 'Tiny' ownerLogins: #(  )) equals: 'Tiny in:name'
]

{ #category : 'tests' }
MiGithubRepositoryTest >> testSearchOwnerLoginsFromOrganizationPart [

	repository at: 'search/users' put: { ('items' -> {
			 { ('login' -> 'jecisc') } asDictionary.
			 { ('login' -> 'jech') } asDictionary } asArray) } asDictionary.

	self assert: (repository searchOwnerLoginsFromOrganizationPart: 'jec') equals: { 'jecisc'. 'jech' }
]

{ #category : 'tests' }
MiGithubRepositoryTest >> testSearchRepositoriesNameOnly [
	"The search of users must not be queried when no organization part is given: the stub raises on unexpected queries."

	repository at: 'search/repositories' put: { ('items' -> { { ('full_name' -> 'jecisc/TinyLogger') } asDictionary } asArray) } asDictionary.

	self assert: (repository searchRepositoriesNamed: 'Tiny' organization: '') size equals: 1
]

{ #category : 'tests' }
MiGithubRepositoryTest >> testSearchRepositoriesNamedAndOrganization [

	repository
		at: 'search/users' put: { ('items' -> { { ('login' -> 'jecisc') } asDictionary } asArray) } asDictionary;
		at: 'search/repositories' put: { ('items' -> { { ('full_name' -> 'jecisc/TinyLogger') } asDictionary } asArray) } asDictionary.

	self assert: (repository searchRepositoriesNamed: 'Tiny' organization: 'jec') size equals: 1.
	self assert: ((repository searchRepositoriesNamed: 'Tiny' organization: 'jec') first at: 'full_name') equals: 'jecisc/TinyLogger'
]

{ #category : 'tests' }
MiGithubRepositoryTest >> testSearchRepositoriesOrganizationOnly [

	repository
		at: 'search/users' put: { ('items' -> { { ('login' -> 'jecisc') } asDictionary } asArray) } asDictionary;
		at: 'search/repositories' put: { ('items' -> { { ('full_name' -> 'jecisc/TinyLogger') } asDictionary } asArray) } asDictionary.

	self assert: (repository searchRepositoriesNamed: '' organization: 'jec') size equals: 1
]

{ #category : 'tests' }
MiGithubRepositoryTest >> testSearchRepositoriesUnknownOrganization [
	"When the organization part matches no owner the search must answer empty without querying the repositories: the stub raises on unexpected queries."

	repository at: 'search/users' put: { ('items' -> #(  )) } asDictionary.

	self assertEmpty: (repository searchRepositoriesNamed: 'Tiny' organization: 'zzzqqq')
]

{ #category : 'tests' }
MiGithubRepositoryTest >> testSearchRepositoriesWithoutParts [
	"The stub raises on unexpected queries, so this asserts that no query is sent when no part is given."

	self assertEmpty: (repository searchRepositoriesNamed: '' organization: '')
]

{ #category : 'tests' }
MiGithubRepositoryTest >> testTags [

	repository at: 'repos/moosetechnology/MooseIDE/tags' put: { { ('name' -> 'v1.0') } asDictionary }.

	self assert: repository tags size equals: 1.
	self assert: repository tags anyOne displayName equals: 'v1.0'.
	self assert: repository tags anyOne kind equals: #tag.
	self assert: repository tags anyOne downloadRef equals: 'refs/tags/v1.0'
]

{ #category : 'fixtures' }
MiGithubRepositoryTest >> tokenCredential [

	^ IceTokenCredentials new
		  token: 'ghp_fakeToken';
		  username: 'testUser';
		  host: 'github.com';
		  yourself
]
