Class {
	#name : #GtBaselinePackageCompletionStrategy,
	#superclass : #GtBaselineCompletionStrategy,
	#category : #'GToolkit-Coder-Completion'
}

{ #category : #private }
GtBaselinePackageCompletionStrategy >> namesMatching: aString [
	^ (RPackageOrganizer default packages
		select: [ :each | each name beginsWith: aString ])
		collect: [ :each | each name ]
]
