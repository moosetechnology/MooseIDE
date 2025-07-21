Class {
	#name : #MiDirectoriesAsRootNodesSettingCommand,
	#superclass : #MiBooleanSettingCommand,
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #default }
MiDirectoriesAsRootNodesSettingCommand class >> defaultDescription [

	^ 'Experimental feature. Show the source files/directories containing entites as root nodes in the map'
]

{ #category : #default }
MiDirectoriesAsRootNodesSettingCommand class >> defaultName [

	^ 'Show directories as root nodes (experimental)'
]

{ #category : #accessing }
MiDirectoriesAsRootNodesSettingCommand >> currentValue [

	^ self context showDirectoriesAsRootNodes
]

{ #category : #accessing }
MiDirectoriesAsRootNodesSettingCommand >> execute: aBoolean [

	^ self context showDirectoriesAsRootNodes: aBoolean
]
