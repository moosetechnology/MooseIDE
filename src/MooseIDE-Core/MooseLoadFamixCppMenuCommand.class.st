"
This class adds a menu item to load github://moosetechnology/Famix-CPP
"
Class {
	#name : #MooseLoadFamixCppMenuCommand,
	#superclass : #MooseAbstractLoadFamixMenuCommand,
	#category : #'MooseIDE-Core-MenuBar'
}

{ #category : #accessing }
MooseLoadFamixCppMenuCommand class >> help [

	^ 'Famix Metamodel for C++'
]

{ #category : #accessing }
MooseLoadFamixCppMenuCommand class >> label [

	^ 'Famix-Cpp'
]

{ #category : #accessing }
MooseLoadFamixCppMenuCommand class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ (self menuCommandOn: aBuilder forCommand: self)
		  withSeparatorAfter;
		  yourself
]

{ #category : #accessing }
MooseLoadFamixCppMenuCommand class >> menuPriority [

	^super menuPriority + 2
]

{ #category : #accessing }
MooseLoadFamixCppMenuCommand >> baselineName [

	^ 'FamixCpp'
]

{ #category : #accessing }
MooseLoadFamixCppMenuCommand >> repositoryURL [

	^ 'github://moosetechnology/Famix-Cpp:' , self version , '/src'
]

{ #category : #accessing }
MooseLoadFamixCppMenuCommand >> version [

	^ 'v1.0.1'
]
