Class {
	#name : #GtBaselinePackageCompletionStrategy,
	#superclass : #GtBaselineCompletionStrategy,
	#category : #'GToolkit-Coder-AddOns-Expandable baseline'
}

{ #category : #private }
GtBaselinePackageCompletionStrategy >> namesMatching: aString [
	^ (RPackageOrganizer default packages
		select: [ :each | each name beginsWith: aString ])
		collect: [ :each | each name ]
]
