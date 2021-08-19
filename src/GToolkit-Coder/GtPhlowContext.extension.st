Extension { #name : 'GtPhlowContext' }

{ #category : '*GToolkit-Coder' }
GtPhlowContext >> hasPackageCoder [
	^ self hasOptionAt: #packageCoder
]

{ #category : '*GToolkit-Coder' }
GtPhlowContext >> hasPackageTagCoder [
	^ self hasOptionAt: #packageTagCoder
]

{ #category : '*GToolkit-Coder' }
GtPhlowContext >> packageCoder [
	^ self 
		optionAt: #packageCoder 
		ifAbsent: [ nil ]
]

{ #category : '*GToolkit-Coder' }
GtPhlowContext >> packageCoder: aCoder [
	self 
		optionAt: #packageCoder put: aCoder
]

{ #category : '*GToolkit-Coder' }
GtPhlowContext >> packageTagCoder [
	^ self 
		optionAt: #packageTagCoder 
		ifAbsent: [ nil ]
]

{ #category : '*GToolkit-Coder' }
GtPhlowContext >> packageTagCoder: aCoder [
	self 
		optionAt: #packageTagCoder put: aCoder
]
