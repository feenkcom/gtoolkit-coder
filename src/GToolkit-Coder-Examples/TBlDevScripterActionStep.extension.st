Extension { #name : #TBlDevScripterActionStep }

{ #category : #'*GToolkit-Coder-Examples' }
TBlDevScripterActionStep >> coderNavigationIndex [
	^ self addStep: GtCoderNavigationIndexStep new referenceSender
]
