"
I represent a Github project (an owner and a project name) and I am the access point of the Github importer to the Github API (through IceGitHubAPI).

I can also search for repositories matching a part of a project name and/or a part of an organization name with #searchRepositoriesNamed:organization:.

I query the information of the repository, its primary language and the available versions: tags, branches, releases and pull requests (see #availableVersions).
I also know the URL from which the sources of a version can be downloaded (see #downloadUrlForVersion:).

I authenticate the requests with the credentials stored for github.com in the Iceberg credential store (see class>>pickGithubCredentialFrom:) when there are some: with a Github personal access token the rate limit goes from 60 requests per hour to 5000.
"
Class {
	#name : 'MiGithubRepository',
	#superclass : 'Object',
	#instVars : [
		'owner',
		'projectName'
	],
	#category : 'MooseIDE-Github-Importer-Model',
	#package : 'MooseIDE-Github-Importer',
	#tag : 'Model'
}

{ #category : 'instance creation' }
MiGithubRepository class >> fromFullName: aString [
	"I parse the path of a repository ('owner/project' potentially followed by more path segments) into a repository. I answer nil if the path does not contain an owner and a project name."

	| segments |
	segments := (aString splitOn: $/) select: #isNotEmpty.
	segments size < 2 ifTrue: [ ^ nil ].
	^ self owner: segments first projectName: (segments second removeSuffix: '.git')
]

{ #category : 'accessing' }
MiGithubRepository class >> maximumSearchQuerySize [
	"I am the maximum size of the query accepted by the Github search of repositories."

	^ 256
]

{ #category : 'instance creation' }
MiGithubRepository class >> owner: ownerString projectName: projectString [

	^ self new
		  owner: ownerString;
		  projectName: projectString;
		  yourself
]

{ #category : 'credentials' }
MiGithubRepository class >> pickGithubCredentialFrom: aCollectionOfCredentials [
	"I pick the credentials stored for github.com to authenticate the requests of the Github API: a token credential if the user stored one (used as a Bearer authorization header), otherwise a plaintext credential (used as basic authentification). I answer nil if no present credential is stored for github.com so that the Github API is queried anonymously."

	| githubCredentials |
	githubCredentials := aCollectionOfCredentials select: [ :each | each host = 'github.com' and: [ each isPresent ] ].
	^ githubCredentials
		  detect: [ :each | each class = IceTokenCredentials ]
		  ifNone: [
				  githubCredentials
					  detect: [ :each | each class = IcePlaintextCredentials ]
					  ifNone: [ nil ] ]
]

{ #category : 'instance creation' }
MiGithubRepository class >> searchRepositoriesNamed: aNamePart organization: anOrganizationPart [

	^ self new searchRepositoriesNamed: aNamePart organization: anOrganizationPart
]

{ #category : 'credentials' }
MiGithubRepository class >> storedGithubCredentials [

	^ self pickGithubCredentialFrom: IceCredentialStore current allCredentials
]

{ #category : 'private' }
MiGithubRepository >> api [

	| githubApi |
	githubApi := IceGitHubAPI new.
	self class storedGithubCredentials ifNotNil: [ :credentials | githubApi credentials: credentials ].
	^ githubApi
]

{ #category : 'requesting' }
MiGithubRepository >> availableVersions [
	"I answer all the versions of the project that can be downloaded and imported: tags, branches, releases and pull requests."

	^ self tags , self branches , self releases , self pullRequests
]

{ #category : 'requesting' }
MiGithubRepository >> branches [

	^ (self get: 'repos/' , self repositoryPath , '/branches') collect: [ :each | MiGithubVersion branchNamed: (each at: 'name') ]
]

{ #category : 'requesting' }
MiGithubRepository >> downloadUrlForVersion: aVersion [
	"I answer the URL of the tarball of the sources of aVersion."

	^ 'https://codeload.github.com/' , self repositoryPath , '/tar.gz/' , aVersion downloadRef
]

{ #category : 'requesting' }
MiGithubRepository >> get: aPath [
	"I query the Github API (anonymous for now). Subclasses can override me for tests."

	^ self api get: aPath
]

{ #category : 'requesting' }
MiGithubRepository >> get: aPath parameters: aDictionary [
	"I query the Github API with parameters, URL-encoding the parameter values because IceGitHubAPI does not encode them. Subclasses can override me for tests."

	| encodedParameters |
	encodedParameters := String streamContents: [ :stream |
			                     aDictionary associations
				                     do: [ :association |
						                     stream
							                     << association key;
							                     << '=';
							                     << association value asString urlEncoded ]
				                     separatedBy: [ stream << '&' ] ].
	^ self get: aPath , '?' , encodedParameters
]

{ #category : 'accessing' }
MiGithubRepository >> owner [

	^ owner
]

{ #category : 'accessing' }
MiGithubRepository >> owner: anObject [

	owner := anObject
]

{ #category : 'requesting' }
MiGithubRepository >> primaryLanguage [
	"I answer the primary language of the project as given by the Github API, or nil if the Github API does not know it."

	^ self repositoryInformation at: 'language'
]

{ #category : 'accessing' }
MiGithubRepository >> projectName [

	^ projectName
]

{ #category : 'accessing' }
MiGithubRepository >> projectName: anObject [

	projectName := anObject
]

{ #category : 'requesting' }
MiGithubRepository >> pullRequests [
	"I only list the open pull requests for now."

	^ (self get: 'repos/' , self repositoryPath , '/pulls') collect: [ :each | MiGithubVersion pullRequestNumber: (each at: 'number') title: (each at: 'title') ]
]

{ #category : 'private' }
MiGithubRepository >> queryTermsFromNamePart: aNamePart ownerLogins: aCollectionOfLogins [

	| terms |
	terms := OrderedCollection new.
	aNamePart ifNotEmpty: [ terms add: aNamePart , ' in:name' ].
	terms addAll: (aCollectionOfLogins collect: [ :aLogin | 'user:' , aLogin ]).
	^ terms
]

{ #category : 'requesting' }
MiGithubRepository >> releases [

	^ (self get: 'repos/' , self repositoryPath , '/releases') collect: [ :each | MiGithubVersion releaseNamed: (each at: 'tag_name') ]
]

{ #category : 'requesting' }
MiGithubRepository >> repositoryInformation [

	^ self get: 'repos/' , self repositoryPath
]

{ #category : 'requesting' }
MiGithubRepository >> repositoryPath [

	^ owner , '/' , projectName
]

{ #category : 'private' }
MiGithubRepository >> repositorySearchQueryFromNamePart: aNamePart ownerLogins: aCollectionOfLogins [
	"I build the query of the Github repository search: the project name part must match the repository name and each owner login is an exact owner filter. Github limits the size of a query, so I drop the last owner logins while the query is too long."

	| keptLogins |
	keptLogins := aCollectionOfLogins.
	[ keptLogins isNotEmpty and: [ ((self queryTermsFromNamePart: aNamePart ownerLogins: keptLogins) joinUsing: ' ') size > self class maximumSearchQuerySize ] ]
		whileTrue: [ keptLogins := keptLogins allButLast ].
	^ (self queryTermsFromNamePart: aNamePart ownerLogins: keptLogins) joinUsing: ' '
]

{ #category : 'requesting' }
MiGithubRepository >> searchOwnerLoginsFromOrganizationPart: anOrganizationPart [
	"I resolve the organization part of the search into owner logins with the Github user search. I answer at most the logins of the first owners matched by Github, ranked by relevance, so an exact organization name is always resolved. I can answer an empty collection if no owner matches."

	^ ((self get: 'search/users' parameters: {
			    ('q' -> (anOrganizationPart , ' in:login')).
			    ('per_page' -> 20) } asDictionary) at: 'items') collect: [ :each | each at: 'login' ]
]

{ #category : 'requesting' }
MiGithubRepository >> searchRepositoriesFromQuery: aQuery [
	"We display 50 results by page."

	^ (self get: 'search/repositories' parameters: {
			   ('q' -> aQuery).
			   ('per_page' -> 50) } asDictionary) at: 'items'
]

{ #category : 'requesting' }
MiGithubRepository >> searchRepositoriesNamed: projectPattern organization: organizationPattern [
	"I search Github for the repositories matching a part of a project name and/or a part of an organization name. I answer the raw items of the Github search results: dictionaries with 'full_name', 'description', 'language', ...
	The organization part is resolved into owner logins with a user search because the search of repositories only filters on exact owner logins (see #searchOwnerLoginsFromOrganizationPart:). If the organization part matches no owner I answer an empty result instead of searching without the organization filter."

	(projectPattern isEmpty and: [ organizationPattern isEmpty ]) ifTrue: [ ^ #(  ) ].

	organizationPattern ifEmpty: [ ^ self searchRepositoriesFromQuery: (self repositorySearchQueryFromNamePart: projectPattern ownerLogins: #(  )) ].

	^ (self searchOwnerLoginsFromOrganizationPart: organizationPattern)
		  ifEmpty: [ #(  ) ]
		  ifNotEmpty: [ :ownerLogins | self searchRepositoriesFromQuery: (self repositorySearchQueryFromNamePart: projectPattern ownerLogins: ownerLogins) ]
]

{ #category : 'requesting' }
MiGithubRepository >> tags [

	^ (self get: 'repos/' , self repositoryPath , '/tags') collect: [ :each | MiGithubVersion tagNamed: (each at: 'name') ]
]
