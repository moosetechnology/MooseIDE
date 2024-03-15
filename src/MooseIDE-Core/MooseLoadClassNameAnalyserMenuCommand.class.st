"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.


    Implementation Points
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

{ #category : #'world menu' }
MooseLoadClassNameAnalyserMenuCommand class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self menuCommandOn: aBuilder forCommand: self
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
