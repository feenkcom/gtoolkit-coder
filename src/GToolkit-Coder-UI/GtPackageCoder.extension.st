Extension { #name : #GtPackageCoder }

{ #category : #'*GToolkit-Coder-UI' }
GtPackageCoder >> asCardElement [
	^ GtPackageCardElement new coder: self
]

{ #category : #'*GToolkit-Coder-UI' }
GtPackageCoder >> asCoderUIModel [
	^ GtPackageCoderUIModel new coder: self
]
