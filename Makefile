COBOL = cobc
SQLPP = gixsql

SRC = src
DB = db

all: app

policy_insert.cob:
	$(SQLPP) $(DB)/policy_insert.cbl

policy_select.cob:
	$(SQLPP) $(DB)/policy_select.cbl

app: policy_insert.cob policy_select.cob
	$(COBOL) -x -o app \
	$(SRC)/main.cbl \
	$(SRC)/policy_service.cbl \
	$(SRC)/standard_policy.cbl \
	$(SRC)/health_policy.cbl \
	$(SRC)/rider_service.cbl \
	policy_insert.cob \
	policy_select.cob

clean:
	rm -f app *.cob