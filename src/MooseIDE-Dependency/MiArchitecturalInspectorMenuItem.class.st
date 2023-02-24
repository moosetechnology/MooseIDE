Class {
	#name : #MiArchitecturalInspectorMenuItem,
	#superclass : #MiArchitecturalMenuItem,
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #accessing }
MiArchitecturalInspectorMenuItem >> canBeExecuted [

	^ shape isShape
]

{ #category : #execution }
MiArchitecturalInspectorMenuItem >> execute [
	shape inspectOnMoose
]

{ #category : #accessing }
MiArchitecturalInspectorMenuItem >> group [

	^ 100
]

{ #category : #accessing }
MiArchitecturalInspectorMenuItem >> iconName [
	^ #smallInspectIt
]

{ #category : #accessing }
MiArchitecturalInspectorMenuItem >> label [
	^ 'Inspect'
]

{ #category : #accessing }
MiArchitecturalInspectorMenuItem >> order [
	^ 100
]
