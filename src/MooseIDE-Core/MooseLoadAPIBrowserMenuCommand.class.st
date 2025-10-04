"
A command to load the ClassNameAnalyzer project.

The ClassNameAnalyser is a project which provides a visualisation of the distribution of concepts in both Java and Pharo. The visualization is called ClassName Distribution.

https://github.com/moosetechnology/ClassNameAnalyser
"
Class {
	#name : 'MooseLoadAPIBrowserMenuCommand',
	#superclass : 'MooseAbstractLoadToolMenuCommand',
	#category : 'MooseIDE-Core-MenuBar',
	#package : 'MooseIDE-Core',
	#tag : 'MenuBar'
}

{ #category : 'accessing' }
MooseLoadAPIBrowserMenuCommand class >> label [

	^ 'API browser'
]

{ #category : 'world menu' }
MooseLoadAPIBrowserMenuCommand class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ (self menuCommandOn: aBuilder forCommand: self) yourself
]

{ #category : 'accessing' }
MooseLoadAPIBrowserMenuCommand class >> menuPriority [

	^ super menuPriority + 2
]

{ #category : 'accessing' }
MooseLoadAPIBrowserMenuCommand >> baselineName [

	^ 'APIBrowser'
]

{ #category : 'accessing' }
MooseLoadAPIBrowserMenuCommand >> repositoryURL [

	^ 'github://moosetechnology/APIBrowser' , self version , '/src'
]

{ #category : 'accessing' }
MooseLoadAPIBrowserMenuCommand >> version [

	^ 'master'
]
