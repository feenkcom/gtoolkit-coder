Class {
	#name : #GtBaselinesCompletionStrategy,
	#superclass : #GtClassesCompletionStrategy,
	#category : #'GToolkit-Coder-Completion'
}

{ #category : #accessing }
GtBaselinesCompletionStrategy >> candidateClasses [
	^  super candidateClasses select: [:aClassName | aClassName beginsWith: 'BaselineOf' ]
]
