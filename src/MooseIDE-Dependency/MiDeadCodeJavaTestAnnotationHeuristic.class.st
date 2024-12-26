Class {
	#name : #MiDeadCodeJavaTestAnnotationHeuristic,
	#superclass : #MiDeadCodeAbstractTestHeuristic,
	#category : #'MooseIDE-Dependency-DeadCode'
}

{ #category : #accessing }
MiDeadCodeJavaTestAnnotationHeuristic >> description [ 

	^super description , '
	In Java, different annotations mark methods of test class
	 (@Test, @Before, @BeforeEach,...)'
]

{ #category : #testing }
MiDeadCodeJavaTestAnnotationHeuristic >> isDead: aTMethod [

	^aTMethod annotationInstances
		ifNotEmpty: [ :annots |
			(annots anySatisfy: [ :ann |
				(self junit4Annotations includes: ann annotationType name) or:
				[self junit5Annotations includes: ann annotationType name] ]) ].

]

{ #category : #testing }
MiDeadCodeJavaTestAnnotationHeuristic >> junit4Annotations [
	"from https://www.softwaretestinghelp.com/junit-annotations-tutorial/"

	^{ 'Test' . 'Before' . 'After' . 'BeforeClass' . 'AfterClass' }
]

{ #category : #testing }
MiDeadCodeJavaTestAnnotationHeuristic >> junit5Annotations [
	"from https://junit.org/junit5/docs/current/user-guide/
	other possibilities: DisplayName, DisplayNameGeneration, Nested, Tag, Disabled, AutoClose, TempDir, ExtendWith, RegisterExtension"

	^{ 'Test' . 'ParameterizedTest' . 'RepeatedTest' . 'TestFactory' . 'TestTemplate' . 'TestClassOrder' . 'TestMethodOrder' . 'TestInstance' . 'BeforeEach' . 'AfterEach' . 'BeforeAll' . 'AfterAll' . 'Timeout' }

]

{ #category : #accessing }
MiDeadCodeJavaTestAnnotationHeuristic >> name [

	^'Test: Java @Test method'
]
