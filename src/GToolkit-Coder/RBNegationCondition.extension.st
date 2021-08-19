Extension { #name : 'RBNegationCondition' }

{ #category : '*GToolkit-Coder' }
RBNegationCondition >> gtChildren [
	^ condition gtChildren collect: [ :eachCondition | eachCondition not ]
]
