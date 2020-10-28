Extension { #name : #GtPhlowContext }

{ #category : #'*GToolkit-Coder' }
GtPhlowContext >> hasPackageTagCoder [
	^ self hasOptionAt: #packageTagCoder
]

{ #category : #'*GToolkit-Coder' }
GtPhlowContext >> packageTagCoder [
	^ self 
		optionAt: #packageTagCoder 
		ifAbsent: [ nil ]
]

{ #category : #'*GToolkit-Coder' }
GtPhlowContext >> packageTagCoder: aCoder [
	self 
		optionAt: #packageTagCoder put: aCoder
]
