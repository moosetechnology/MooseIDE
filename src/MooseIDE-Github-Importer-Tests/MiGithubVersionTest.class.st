"
I test MiGithubVersion: the refs used to download a version and the name of its download folder.
"
Class {
	#name : 'MiGithubVersionTest',
	#superclass : 'TestCase',
	#category : 'MooseIDE-Github-Importer-Tests-Tests',
	#package : 'MooseIDE-Github-Importer-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
MiGithubVersionTest >> testBranchFolderNameWithSlash [

	self assert: (MiGithubVersion branchNamed: 'feature/my-branch') folderName equals: 'feature-my-branch'
]

{ #category : 'tests' }
MiGithubVersionTest >> testPullRequestDownloadRef [

	self assert: (MiGithubVersion pullRequestNumber: 42 title: 'Fix bug') downloadRef equals: 'refs/pull/42/head'
]

{ #category : 'tests' }
MiGithubVersionTest >> testPullRequestFolderName [

	self assert: (MiGithubVersion pullRequestNumber: 42 title: 'Fix bug') folderName equals: 'PR-42'
]

{ #category : 'tests' }
MiGithubVersionTest >> testReleaseDownloadRef [

	self assert: (MiGithubVersion releaseNamed: 'v1.0') downloadRef equals: 'refs/tags/v1.0'
]

{ #category : 'tests' }
MiGithubVersionTest >> testTagFolderName [

	self assert: (MiGithubVersion tagNamed: 'v1.0') folderName equals: 'v1.0'
]
