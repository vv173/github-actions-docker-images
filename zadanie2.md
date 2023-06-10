Repozytorium zawiera w sobie trzy pliki workflow. Każdy z tych workflow do GitHub Action buduje obraz, skanuje podatności CVE jednym z trzech narzędzi oraz wrzuca zbudowany obrazy do github registry.

1) **Plik docker-ci-snyk.yml. (Job: Docker Image CI with Snyk)**
Job pobiera zawartość repozytorium poprzez checkout. Uruchamia qemu oraz silnik buildx do budowania obrazów wieloplatformowych. Najpierw zostaje zbudowany obraz lokalnie (w github) bez określonej architektury. Następnie obraz zostanie przeskanowany narzędziem scout, w przypadku wykrycia przynajmniej jednej podatności krytycznej, job zostanie przerwany. Pod czas skanowania obrazu zostanie wygenerowany raport w formacie sarif, który później będzie wrzucony do github reports. Dalej „Job” loguje się do ghcr.io. Ostatnim krokiem jest budowanie obrazu „app-snyk” dla platform x86_64 oraz arm64 i push obrazu do registry. Cache obrazu jest zapisywany w trybie inline.

*Ten workflow nie buduje obrazu x86_64 dwukrotnie. Obraz jest budowany raz, a kolejne kroki wykorzystują wewnętrzną pamięć podręczną z pierwszego kroku Build and push. Drugi krok Build and push buduje tylko arm64.*

2) **Plik docker-ci-scout.yml (Job: Docker Image CI with Scout)**
Job pobiera zawartość repozytorium poprzez checkout. Uruchamia qemu oraz silnik buildx do budowania obrazów wieloplatformowych. Następnie „Job” loguje się do ghcr.io. Dalej następuje budowanie obrazu „app-scout” dla platform x86_64 oraz arm64 i push obrazu do registry. Ostatnim krokiem jest porównywanie obrazu zbudowanego lokalnie do obrazu z registry za pomocą narzędzia docker scout. Obecnie podane rozwiązanie nie działa poprawnie, ponieważ scout nie jest w stanie znaleźć obraz z ghcr.io. Prawdopodobnie problem występuje po stronie „action” jako rozwiązanie należy zamienić gotowy action poleceniem w cli.

3) **Plik docker-ci-neuvector.yml (Job: Docker Image CI with NeuVector)**
Job działa w dokładnie taki samy sposób jak „Docker Image CI with Snyk”. Różnie się tylko tym, że skanowanie obrazu jest przeprowadzane dwa razy. Pierwszy raz jest skanowany obraz zbudowany lokalnie, za drugim razem skanowany jest obraz z zdalnego registry. 
