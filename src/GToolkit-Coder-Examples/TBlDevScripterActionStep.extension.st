Extension { #name : #TBlDevScripterActionStep }

{ #category : #'*GToolkit-Coder-Examples' }
TBlDevScripterActionStep >> coderNavigationIndex [
	<scripterActionStep>
	
	^ self addStep: GtCoderNavigationIndexStep new referenceSender
]
