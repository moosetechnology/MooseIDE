"
A command to load the ClassNameAnalyzer project.

The ClassNameAnalyser is a project which provides a visualisation of the distribution of concepts in both Java and Pharo. The visualization is called ClassName Distribution.

https://github.com/moosetechnology/ClassNameAnalyser
"
Class {
	#name : #MooseLoadClassNameAnalyserMenuCommand,
	#superclass : #MooseAbstractLoadToolMenuCommand,
	#category : #'MooseIDE-Core-MenuBar'
}

{ #category : #accessing }
MooseLoadClassNameAnalyserMenuCommand class >> label [

	^ 'Class Name Analyser'
]

{ #category : #accessing }
MooseLoadClassNameAnalyserMenuCommand class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ (self menuCommandOn: aBuilder forCommand: self) yourself
]

{ #category : #accessing }
MooseLoadClassNameAnalyserMenuCommand class >> menuPriority [

	^ super menuPriority + 2
]

{ #category : #accessing }
MooseLoadClassNameAnalyserMenuCommand >> baselineName [

	^ 'ClassNameAnalyser'
]

{ #category : #accessing }
MooseLoadClassNameAnalyserMenuCommand >> repositoryURL [

	^ 'github://moosetechnology/ClassNameAnalyser:' , self version , '/src'
]

{ #category : #accessing }
MooseLoadClassNameAnalyserMenuCommand >> version [

	^ 'master'
]
