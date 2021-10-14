Extension { #name : #SharedPool }

{ #category : #'*GToolkit-Coder' }
SharedPool class >> associationsDo: aBlock [
	^ self bindingsDo: aBlock
]
